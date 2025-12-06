
import React from 'react';
import { Tag, Users, MapPin, Clock, Heart, Music, Film, BookOpen, Coffee } from 'lucide-react';
import { motion } from 'framer-motion';

interface PopularSearchesProps {
  onTagClick: (tag: string, type: 'all' | 'profiles' | 'tags' | 'cities') => void;
}

interface CategoryTags {
  title: string;
  icon: React.ReactNode;
  tags: Array<{name: string; type: 'all' | 'profiles' | 'tags' | 'cities'}>;
}

const PopularSearches: React.FC<PopularSearchesProps> = ({ onTagClick }) => {
  const categories: CategoryTags[] = [
    {
      title: "Roles",
      icon: <Users className="w-4 h-4" />,
      tags: [
        { name: "Top", type: "tags" },
        { name: "Bottom", type: "tags" },
        { name: "Versatile", type: "tags" },
        { name: "Muscular", type: "tags" },
        { name: "Jock", type: "tags" },
        { name: "Twink", type: "tags" },
        { name: "Bear", type: "tags" }
      ]
    },
    {
      title: "Status",
      icon: <Clock className="w-4 h-4" />,
      tags: [
        { name: "Online Now", type: "all" },
        { name: "New Guys", type: "profiles" },
        { name: "Recently Active", type: "profiles" }
      ]
    },
    {
      title: "Locations",
      icon: <MapPin className="w-4 h-4" />,
      tags: [
        { name: "San Francisco", type: "cities" },
        { name: "New York", type: "cities" },
        { name: "Los Angeles", type: "cities" },
        { name: "Chicago", type: "cities" },
        { name: "Miami", type: "cities" }
      ]
    },
    {
      title: "Interests",
      icon: <Tag className="w-4 h-4" />,
      tags: [
        { name: "Gaming", type: "tags" },
        { name: "Fitness", type: "tags" },
        { name: "Travel", type: "tags" },
        { name: "Art", type: "tags" },
        { name: "Technology", type: "tags" }
      ]
    },
    {
      title: "Relationship Goals",
      icon: <Heart className="w-4 h-4" />,
      tags: [
        { name: "Dating", type: "tags" },
        { name: "Friends", type: "tags" },
        { name: "Long-term", type: "tags" },
        { name: "Casual", type: "tags" }
      ]
    },
    {
      title: "Entertainment",
      icon: <Film className="w-4 h-4" />,
      tags: [
        { name: "Movies", type: "tags" },
        { name: "Music", type: "tags" },
        { name: "Reading", type: "tags" },
        { name: "TV Shows", type: "tags" }
      ]
    }
  ];
  
  return (
    <motion.div 
      className="mt-4"
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <h3 className="text-[#C2FFE6] font-medium mb-3 neon-text">Popular Searches</h3>
      
      <div className="space-y-4">
        {categories.map((category, idx) => (
          <motion.div 
            key={idx} 
            className="space-y-2"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3, delay: idx * 0.1 }}
          >
            <div className="flex items-center gap-2 text-sm text-[#C2FFE6]/70">
              {category.icon}
              <span>{category.title}</span>
            </div>
            
            <div className="flex flex-wrap gap-2">
              {category.tags.map(tag => (
                <motion.button 
                  key={tag.name}
                  onClick={() => onTagClick(tag.name, tag.type)}
                  className="px-3 py-1 rounded-full text-sm ring-button neon-text neon-border flex items-center gap-1"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  {tag.name}
                </motion.button>
              ))}
            </div>
          </motion.div>
        ))}
      </div>
    </motion.div>
  );
};

export default PopularSearches;
