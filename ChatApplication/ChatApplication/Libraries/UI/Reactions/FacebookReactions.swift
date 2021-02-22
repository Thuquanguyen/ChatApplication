/*
 * Reactions
 *
 * Copyright 2016-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

/// Default implementation of the facebook reactions.
extension Reaction {
    /// Struct which defines the standard facebook reactions.
    public struct facebook {
        /// The facebook's "like" reaction.
        public static var like: Reaction {
            return reactionWithId(1)
        }
        
        /// The facebook's "love" reaction.
        public static var love: Reaction {
            return reactionWithId(2)
        }
        
        /// The facebook's "haha" reaction.
        public static var haha: Reaction {
            return reactionWithId(4)
        }
        
        /// The facebook's "wow" reaction.
        public static var wow: Reaction {
            return reactionWithId(3)
        }
        
        /// The facebook's "sad" reaction.
        public static var sad: Reaction {
            return reactionWithId(5)
        }
        
        /// The facebook's "angry" reaction.
        public static var angry: Reaction {
            return reactionWithId(6)
        }
        
        /// The facebook's "angry" reaction.
        public static var normal: Reaction {
            return reactionWithId(0)
        }
        
        /// The list of standard facebook reactions in this order: `.like`, `.love`, `.haha`, `.wow`, `.sad`, `.angry`.
        public static let all: [Reaction] = [facebook.like, facebook.love, facebook.haha, facebook.wow, facebook.sad, facebook.angry]
        
        // MARK: - Convenience Methods
        
        static func reactionWithId(_ id: Int) -> Reaction {
            var title: String = "L10n.reactionLike"
            var color: UIColor            = .black
            var backgroundColor: UIColor  = .black
            var titleColor: UIColor  = .black
            var alternativeIcon: UIImage? = nil
            
            switch id {
            case 1:
                title = "L10n.reactionLike"
                color = UIColor("2196F3").alpha(0.75)
                backgroundColor = UIColor("2196F3").alpha(0.1)
                titleColor = UIColor("2196F3")
                alternativeIcon = UIImage()
            case 2:
                title = "L10n.reactionLove"
                color = UIColor("E64B4B").alpha(0.75)
                backgroundColor = UIColor("E64B4B").alpha(0.1)
                titleColor = UIColor("E64B4B")
                alternativeIcon = UIImage()
            case 4:
                title = "L10n.reactionFunny"
                color = UIColor("FFCA28")
                backgroundColor = UIColor("FFF4D4")
                titleColor = UIColor("6D4C41")
            case 3:
                title = "L10n.reactionWow"
                color = UIColor("FFCA28")
                backgroundColor = UIColor("FFF4D4")
                titleColor = UIColor("6D4C41")
            case 5:
                title = "L10n.reactionSad"
                color = UIColor("FFCA28")
                backgroundColor = UIColor("FFF4D4")
                titleColor = UIColor("6D4C41")
            case 6:
                title = "L10n.reactionDislike"
                color = UIColor("FA6400").alpha(0.75)
                backgroundColor = UIColor("FA6400").alpha(0.1)
                titleColor = UIColor("FA6400")
                alternativeIcon = UIImage()
            default:
                title = "L10n.reactionLike"
                color = UIColor("BDBDBD")
                backgroundColor = UIColor.white
                titleColor = UIColor("3A454D")
            }
            
            return Reaction(id: id, title: title, color: color, backgroundColor: backgroundColor, titleColor: titleColor, icon: imageWithName(id), alternativeIcon: alternativeIcon)
        }
        
        private static func imageWithName(_ id: Int) -> UIImage {
            var image: UIImage
            
            switch id {
            case 1:
                image = UIImage()
            case 2:
                image = UIImage()
            case 4:
                image = UIImage()
            case 3:
                image = UIImage()
            case 5:
                image = UIImage()
            case 6:
                image = UIImage()
            default:
                if id > 0 {
                    image = UIImage()
                } else {
                    image = UIImage()
                }
            }
            
            return image
        }
    }
}
