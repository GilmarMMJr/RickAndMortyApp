//
//  ImageService.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 19/03/25.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void ) {
        let nsURL = url as NSURL
        
        if let cachedImage = cache.object(forKey: nsURL) {
            print("🟢 Imagem carregada do cache: \(url.absoluteString)")
            completion(cachedImage)
            return
        }
        
        print("🔵 Baixando imagem: \(url.absoluteString)")
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self,
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    print("❌ Erro ao carregar imagem: \(url.absoluteString)")
                    completion(UIImage(systemName: "person.circle.fill"))
                }
                return
            }
            
            self.cache.setObject(image, forKey: nsURL)
            DispatchQueue.main.async {
                print("✅ Imagem baixada e salva no cache: \(url.absoluteString)")
                completion(image)
            }
        }
    }
}
