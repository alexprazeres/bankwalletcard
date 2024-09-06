import PassKit
import Flutter
import UIKit

class BankWalletCard: NSObject, PKAddPaymentPassViewControllerDelegate {
    
    static let shared = BankWalletCard()
    var customerId = ""
    
    private override init() {
        super.init()
    }
    
    func configureHttp(baseUrl: String, token: String) {
        HttpConfig.shared.configure(baseUrl: baseUrl, authorizationToken: token)
    }
    
    func startAddPaymentPass(cardholderName: String, primaryAccountSuffix: String, _customerId : String, result: @escaping FlutterResult, viewController: UIViewController) {
        guard PKAddPaymentPassViewController.canAddPaymentPass() else {
            result(FlutterError(code: "UNAVAILABLE_CAN_ADD_PAYMENT_PASS", message: "Cannot add payment pass", details: nil))
            return
        }

        guard let requestConfiguration = PKAddPaymentPassRequestConfiguration(encryptionScheme: .RSA_V2) else {
            result(FlutterError(code: "UNAVAILABLE_PASS_REQUEST_CONFIG", message: "Failed to create request configuration", details: nil))
            return
        }
        
        customerId = _customerId;

        requestConfiguration.cardholderName = cardholderName
        requestConfiguration.primaryAccountSuffix = primaryAccountSuffix
        

        guard let addPaymentPassVC = PKAddPaymentPassViewController(requestConfiguration: requestConfiguration, delegate: self) else {
            result(FlutterError(code: "UNAVAILABLE_VIEW_CONTROLLER", message: "Failed to initialize PKAddPaymentPassViewController", details: nil))
            return
        }

        viewController.present(addPaymentPassVC, animated: true, completion: nil)
    }
    
    func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController, generateRequestWithCertificateChain certificates: [Data], nonce: Data, nonceSignature: Data, completionHandler handler: @escaping (PKAddPaymentPassRequest) -> Void) {
        
        let requestData: [String: Any] = [
            "certificates": certificates.map { $0.base64EncodedString() },
            "nonce": nonce.base64EncodedString(),
            "nonceSignature": nonceSignature.base64EncodedString()
        ]
        
        guard let baseUrl = HttpConfig.shared.baseUrl,
              let url = URL(string: "\(baseUrl)/v3/mob/credit-cards/apply-tokenization?customer_id=\(customerId)") else {
            handler(PKAddPaymentPassRequest()) // Retorna um request vazio em caso de erro
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = HttpConfig.shared.authorizationToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
        } catch {
            print("Erro ao serializar o JSON: \(error.localizedDescription)")
            handler(PKAddPaymentPassRequest()) // Retorna um request vazio em caso de erro
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                handler(PKAddPaymentPassRequest()) // Retorna um request vazio em caso de erro
                return
            }
            
            guard let data = data else {
                print("Erro: dados inválidos recebidos do servidor")
                handler(PKAddPaymentPassRequest()) // Retorna um request vazio em caso de erro
                return
            }

            
            do {
                // Assumindo que o servidor retorna os dados em JSON
                if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                   let activationData = responseDict["activation_data"],
                   let encryptedPassData = responseDict["encrypted_pass_data"],
                   let ephemeralPublicKey = responseDict["ephemeral_public_key"] {
                    
                    // Criar o PKAddPaymentPassRequest
                    let passRequest = PKAddPaymentPassRequest()
                    passRequest.activationData = Data(base64Encoded: activationData)
                    passRequest.encryptedPassData = Data(base64Encoded: encryptedPassData)
                    passRequest.ephemeralPublicKey = Data(base64Encoded: ephemeralPublicKey)
                    
                    // Retornar o request gerado para o PassKit
                    handler(passRequest)
                } else {
                    print("Invalid response from server")
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
            
//            do {
//                
//                let responseData = try JSONDecoder().decode(PaymentPassResponse.self, from: data)
//                print("resposta")
//                print(responseData)
////                let request = PKAddPaymentPassRequest()
////                request.encryptedPassData = Data(base64Encoded: responseData.encryptedPassData) ?? Data()
////                request.activationData = Data(base64Encoded: responseData.activationData) ?? Data()
////                request.ephemeralPublicKey = Data(base64Encoded: responseData.ephemeralPublicKey) ?? Data()
////                
////                handler(request)
//                handler(PKAddPaymentPassRequest()) // Retorna um request vazio em caso de erro
//            } catch {
//                
//                print("Erro ao decodificar a resposta JSON: \(error.localizedDescription)")
//                handler(PKAddPaymentPassRequest()) // Retorna um request vazio em caso de erro
//            }
        }
        
        task.resume()
    }
    
    func addPaymentPassViewController(_ controller: PKAddPaymentPassViewController, didFinishAdding pass: PKPaymentPass?, error: Error?) {
        controller.dismiss(animated: true) {
            if let error = error {
                print("Erro ao adicionar o cartão: \(error.localizedDescription)")
            } else {
                print("Cartão adicionado com sucesso!")
            }
        }
    }
}

// Definir a estrutura para os dados de resposta do servidor
struct PaymentPassResponse: Decodable {
    let encryptedPassData: String
    let activationData: String
    let ephemeralPublicKey: String
}
