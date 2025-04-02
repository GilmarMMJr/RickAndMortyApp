//
//  ImageService.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 19/03/25.
//

import UIKit

class ImageService {
    static let shared = ImageService()
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let expirationTime: TimeInterval = 86400 // 24 horas

    private init() {
        // Define o diretório de cache no sistema de arquivos
        if let cachePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            cacheDirectory = cachePath.appendingPathComponent("ImageCache", isDirectory: true)
        } else {
            fatalError("Erro ao acessar o diretório de cache")
        }

        // Cria o diretório se não existir
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let nsURL = url as NSURL
        let fileURL = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        // 1️⃣ Primeiro verifica se a imagem está na memória (NSCache)
        if let cachedImage = memoryCache.object(forKey: nsURL) {
            print("🟢 Imagem carregada do cache em memória: \(url.absoluteString)")
            completion(cachedImage)
            return
        }

        // 2️⃣ Verifica se a imagem está no armazenamento local e se ainda é válida
        if let diskImage = loadFromDisk(fileURL: fileURL), !isImageExpired(fileURL: fileURL) {
            print("🟡 Imagem carregada do cache no disco: \(fileURL.path)")
            memoryCache.setObject(diskImage, forKey: nsURL) // Adiciona no cache em memória
            completion(diskImage)
            return
        }

        // 3️⃣ Se a imagem não existir ou estiver expirada, faz o download e salva
        print("🔵 Baixando nova imagem: \(url.absoluteString)")
        downloadAndCacheImage(from: url, fileURL: fileURL, nsURL: nsURL, completion: completion)
    }

    private func loadFromDisk(fileURL: URL) -> UIImage? {
        guard fileManager.fileExists(atPath: fileURL.path),
              let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return UIImage(data: imageData)
    }

    private func isImageExpired(fileURL: URL) -> Bool {
        guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
              let creationDate = attributes[.creationDate] as? Date else {
            return true // Se não conseguir pegar a data, considera expirado
        }
        return Date().timeIntervalSince(creationDate) > expirationTime
    }

    private func downloadAndCacheImage(from url: URL, fileURL: URL, nsURL: NSURL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    print("❌ Erro ao baixar imagem: \(url.absoluteString)")
                    completion(UIImage(systemName: "person.circle.fill"))
                }
                return
            }

            // Salva na memória
            self.memoryCache.setObject(image, forKey: nsURL)

            // Salva no disco
            try? data.write(to: fileURL)

            DispatchQueue.main.async {
                print("✅ Imagem baixada e salva no cache: \(fileURL.path)")
                completion(image)
            }
        }
    }

    func clearCache() {
        memoryCache.removeAllObjects()

        do {
            let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for file in contents {
                try fileManager.removeItem(at: file)
            }
            print("🗑 Cache limpo com sucesso!")
        } catch {
            print("❌ Erro ao limpar cache: \(error.localizedDescription)")
        }
    }
}
