import Foundation

public class ApiCaller {
    public static let shared = ApiCaller()
    
    private init() {}
    
    private let url = "https://gist.githubusercontent.com/ashwindmk/25aa12b220c1348f9e99b1ee3f2024ec/raw/9d086ff760f7fe371480c27ba1ee2f349b829ba5/courses.json"
    
    public func fetchCourses(completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: url) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                guard let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        as? [[String: String]] else {  // Type-cast Any as Array<Dictionary<String, String>>
                    completion([])
                    return
                }
                //print("results type = \(type(of: results))")
                
                let courses: [String] = results.compactMap({ dict in
                    return dict["name"] ?? nil
                })
                
                completion(courses)
            } catch {
                completion([])
            }
        }
        task.resume()
    }
}
