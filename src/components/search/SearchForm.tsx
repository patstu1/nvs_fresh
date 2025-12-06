
import React, { useState } from 'react';
import { Search, X, ChevronDown, History, Trash2 } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { Button } from '@/components/ui/button';

interface SearchFormProps {
  searchQuery: string;
  setSearchQuery: (query: string) => void;
  searchType: 'all' | 'profiles' | 'tags' | 'cities';
  setSearchType: (type: 'all' | 'profiles' | 'tags' | 'cities') => void;
  handleSearch: (e: React.FormEvent) => void;
  clearSearch: () => void;
  searchHistory: string[];
  clearSearchHistory: () => void;
}

const SearchForm: React.FC<SearchFormProps> = ({
  searchQuery,
  setSearchQuery,
  searchType,
  setSearchType,
  handleSearch,
  clearSearch,
  searchHistory,
  clearSearchHistory
}) => {
  const [showFilterDropdown, setShowFilterDropdown] = useState(false);
  const [showHistory, setShowHistory] = useState(false);
  
  const getSearchTypeLabel = () => {
    switch(searchType) {
      case 'profiles': return 'Profiles';
      case 'tags': return 'Tags';
      case 'cities': return 'Cities';
      default: return 'All';
    }
  };
  
  return (
    <div className="relative">
      <form onSubmit={handleSearch} className="relative">
        <div className="relative flex items-center bg-[#2A2A2A] rounded-full pr-1 neon-border">
          <Search className="absolute left-3 w-5 h-5 text-yobro-cream" />
          <input
            type="text"
            placeholder="Search YO BRO"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-transparent text-white pl-10 pr-2 py-2 focus:outline-none"
          />
          
          {searchQuery && (
            <button 
              type="button" 
              onClick={clearSearch}
              className="flex items-center justify-center w-7 h-7 rounded-full"
            >
              <X className="w-4 h-4 text-white/70" />
            </button>
          )}
          
          <div className="relative flex">
            <button
              type="button"
              onClick={() => setShowFilterDropdown(!showFilterDropdown)}
              className="flex items-center gap-1 text-sm bg-black px-3 py-1 rounded-full border-2 border-yobro-cream/30 text-yobro-cream mr-1"
            >
              {getSearchTypeLabel()}
              <ChevronDown className="w-4 h-4" />
            </button>
            
            <button
              type="button"
              onClick={() => {
                if (searchHistory.length > 0) {
                  setShowHistory(!showHistory);
                }
              }}
              className={`flex items-center justify-center w-8 h-8 rounded-full mr-1 ${
                searchHistory.length > 0 
                  ? 'text-yobro-cream hover:bg-black/30' 
                  : 'text-yobro-cream/30'
              }`}
            >
              <History className="w-4 h-4" />
            </button>
            
            <Button 
              type="submit" 
              size="sm"
              className="rounded-full py-1 px-3 bg-yobro-cream text-black hover:bg-white"
            >
              Search
            </Button>
          </div>
        </div>
        
        {/* Filter dropdown */}
        <AnimatePresence>
          {showFilterDropdown && (
            <motion.div
              className="absolute z-10 mt-2 right-0 bg-[#2A2A2A] rounded-lg border-2 border-yobro-cream/30 overflow-hidden shadow-xl w-40"
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.2 }}
            >
              {['all', 'profiles', 'tags', 'cities'].map((type) => (
                <button
                  key={type}
                  type="button"
                  className={`w-full text-left px-4 py-2 text-sm hover:bg-[#3A3A3A] ${
                    searchType === type ? 'text-yobro-cream font-medium' : 'text-white'
                  }`}
                  onClick={() => {
                    setSearchType(type as 'all' | 'profiles' | 'tags' | 'cities');
                    setShowFilterDropdown(false);
                  }}
                >
                  {type.charAt(0).toUpperCase() + type.slice(1)}
                </button>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
        
        {/* Search history dropdown */}
        <AnimatePresence>
          {showHistory && searchHistory.length > 0 && (
            <motion.div
              className="absolute z-10 mt-2 left-0 right-0 bg-[#2A2A2A] rounded-lg border-2 border-yobro-cream/30 overflow-hidden shadow-xl"
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.2 }}
            >
              <div className="flex justify-between items-center px-4 py-2 border-b border-yobro-cream/10">
                <span className="text-sm font-medium text-yobro-cream">Recent Searches</span>
                <button
                  type="button"
                  onClick={() => {
                    clearSearchHistory();
                    setShowHistory(false);
                  }}
                  className="text-white/70 hover:text-yobro-cream flex items-center gap-1 text-xs"
                >
                  <Trash2 className="w-3 h-3" />
                  Clear
                </button>
              </div>
              <div className="max-h-64 overflow-y-auto">
                {searchHistory.map((query, index) => (
                  <button
                    key={index}
                    type="button"
                    className="w-full text-left px-4 py-2 text-sm hover:bg-[#3A3A3A] text-white flex items-center gap-2"
                    onClick={() => {
                      setSearchQuery(query);
                      setShowHistory(false);
                    }}
                  >
                    <History className="w-4 h-4 text-white/50" />
                    {query}
                  </button>
                ))}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </form>
    </div>
  );
};

export default SearchForm;
