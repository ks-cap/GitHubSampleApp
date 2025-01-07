import Foundation

struct Page {
    let url: URL
    
    /// Create from a link header received via API.
    init?(nextInLinkHeader linkHeader: String) {
        let regex = /<([^>]*)>; rel="next"/

        guard let urlString = try? regex.firstMatch(in: linkHeader)?.output.1,
              let url = URL(string: .init(urlString)) else {
            return nil
        }

        self.url = url
    }
}
