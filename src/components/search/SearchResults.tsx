import React from 'react';
import { Search, UserRound, Tag, MapPin, AlertCircle } from 'lucide-react';
import { UserProfile } from '@/types/UserProfile';
import UserProfileTile from '../UserProfileTile';
import { motion } from 'framer-motion';

interface SearchResultsProps {
  searchResults: UserProfile[];
  onProfileClick: (id: string) => void;
  clearSearch: () => void;
  searchType: 'all' | 'profiles' | 'tags' | 'cities';
}

const SearchResults: React.FC<SearchResultsProps> = ({
  searchResults,
  onProfileClick,
  clearSearch,
  searchType
}) => {
  // Get the right icon based on search type
  const getSearchIcon = () => {
    switch(searchType) {
      case 'profiles': return <UserRound className="w-6 h-6 text-gray-400" />;
      case 'tags': return <Tag className="w-6 h-6 text-gray-400" />;
      case 'cities': return <MapPin className="w-6 h-6 text-gray-400" />;
      default: return <Search className="w-6 h-6 text-gray-400" />;
    }
  };

  // Get the right empty state message
  const getEmptyStateMessage = () => {
    switch(searchType) {
      case 'profiles': return "No profiles match your search";
      case 'tags': return "No matching tags found";
      case 'cities': return "No matching cities found";
      default: return "No matches found";
    }
  };
  
  // Get suggested search terms based on current search type
  const getSuggestedSearches = () => {
    switch(searchType) {
      case 'profiles':
        return ["Online", "New", "Recently Active"];
      case 'tags':
        return ["Gaming", "Fitness", "Travel", "Music"];
      case 'cities':
        return ["San Francisco", "New York", "Los Angeles"];
      default:
        return ["Online", "Gaming", "San Francisco", "Twink"];
    }
  };
  
  return (
    <motion.div 
      className="mt-4"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.3 }}
    >
      <div className="flex justify-between items-center mb-2">
        <h3 className="text-white font-medium neon-text-white">Results</h3>
        <span className="text-sm text-gray-400 neon-text">{searchResults.length} {searchType === 'profiles' ? 'profiles' : 'results'} found</span>
      </div>
      
      {searchResults.length > 0 ? (
        <motion.div 
          className="grid grid-cols-3 gap-2"
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.3 }}
        >
          {searchResults.map((profile, index) => (
            <motion.div
              key={profile.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.3, delay: index * 0.05 }}
            >
              <UserProfileTile
                id={profile.id}
                image={profile.image}
                name={profile.name}
                age={profile.age}
                emojis={profile.emojis}
                distance={profile.distance}
                lastActive={profile.lastActive}
                onProfileClick={onProfileClick}
                theme="cyberpunk"
                compatibilityScore={Math.floor(Math.random() * 100)}
              />
            </motion.div>
          ))}
        </motion.div>
      ) : (
        <motion.div 
          className="text-center py-8 space-y-4"
          initial={{ scale: 0.9 }}
          animate={{ scale: 1 }}
          transition={{ duration: 0.2 }}
        >
          <div className="w-12 h-12 rounded-full bg-[#2A2A2A] flex items-center justify-center mx-auto mb-4 neon-border">
            {getSearchIcon()}
          </div>
          <p className="text-gray-400 neon-text">{getEmptyStateMessage()}</p>
          
          <div className="mt-6">
            <p className="text-sm text-[#C2FFE6]/70 mb-2">Try searching for:</p>
            <div className="flex flex-wrap justify-center gap-2">
              {getSuggestedSearches().map((term, i) => (
                <motion.button
                  key={i}
                  onClick={() => {
                    clearSearch();
                    onProfileClick('suggestion-' + term);
                  }}
                  className="px-3 py-1 rounded-full text-sm ring-button neon-text neon-border flex items-center gap-1"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  {term}
                </motion.button>
              ))}
            </div>
          </div>
          
          <button 
            onClick={clearSearch}
            className="mt-4 text-yobro-amber neon-text-amber"
          >
            Clear search
          </button>
        </motion.div>
      )}
    </motion.div>
  );
};

export default SearchResults;
