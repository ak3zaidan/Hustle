//
//  UserStats.swift
//  Hustle
//
//  Created by Ahmed Zaidan on 11/22/22.
//

import SwiftUI

struct UserStats: View {
    var body: some View {
        HStack(spacing: 24){
            HStack(spacing: 4){
                Text("807")
                    .bold()
                    .font(.subheadline)
                Text("following")
                    .font(.caption)
                    .foregroundColor(.gray)
                    
            }
            HStack(spacing: 4){
                Text("6.9M")
                    .bold()
                    .font(.subheadline)
                Text("followers")
                    .font(.caption)
                    .foregroundColor(.gray)
                    
            }
            
        }
    }
}

struct UserStats_Previews: PreviewProvider {
    static var previews: some View {
        UserStats()
    }
}
