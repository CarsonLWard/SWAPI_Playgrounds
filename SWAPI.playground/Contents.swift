import Foundation

// People URL: https://swapi.dev/api/people/1/

struct Person: Decodable {
    
    let name: String
    
    let height: String
    
    let mass: String
    
    let hair_color: String
    
    let skin_color: String
    
    let eye_color: String
    
    let birth_year: String
    
    let gender: String
    
    let homeworld: URL
    
    let films: [URL]
    
}

// Films URL: https://swapi.dev/api/films/1/

struct Film: Decodable {
    
    let title: String
    
    let opening_crawl: String
    
    let release_date: String
    
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else {return completion(nil)}
        
        let peopleURL = baseURL.appendingPathComponent("people")
        
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        
        print("finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
        
        
            
            if let error = error {
                
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
                return completion(nil)
                
            }
            
            guard let data = data else {return completion(nil)}
            
            do {
                
                let decoder = JSONDecoder()
                
                let person = try decoder.decode(Person.self, from: data)
                
                return completion(person)
                
            } catch {
                
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
                return completion(nil)
                
            }
            
        }.resume()
        
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
                return completion(nil)
                
            }
            
            guard let data = data else {return completion(nil)}
            
            do {
                
                let decoder = JSONDecoder()
                
                let film = try decoder.decode(Film.self, from: data)
                
                completion(film)
                
            } catch {
                
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
                return completion(nil)
                
            }
            
        }.resume()
        
    }
    
}//End of class

func fetchFilm(url: URL) {
    
  SwapiService.fetchFilm(url: url) { film in
    
      if let film = film {
        
        print(film.title)
        
      }
    
  }
    
}

SwapiService.fetchPerson(id: 10) { person in
    
    if let person = person {
    
        print("Name: \(person.name)\nHeight: \(person.height)\nMass: \(person.mass)\nHair color: \(person.hair_color)\nSkin color: \(person.skin_color)\nEye Color: \(person.eye_color)\nBirth Year: \(person.birth_year)\nGender: \(person.gender)\nHomeworld: \(person.homeworld)\n \nAppears in: ")
        
        for film in person.films {
            
            fetchFilm(url: film)
            
        }
        
    }

}
