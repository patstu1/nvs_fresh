
import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { CheckCircle } from 'lucide-react';
import { Question } from '../types/questionnaireTypes';
import { cn } from '@/lib/utils';

interface QuestionDisplayProps {
  question: Question;
  selectedOptions: string[];
  onOptionClick: (option: string) => void;
}

const QuestionDisplay: React.FC<QuestionDisplayProps> = ({
  question,
  selectedOptions,
  onOptionClick,
}) => {
  return (
    <motion.div
      key={question.id}
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      transition={{ duration: 0.3 }}
      className="min-h-[250px]"
    >
      <h2 className="text-xl font-bold text-[#00FFC4] mb-4">{question.text}</h2>
      
      <div className="space-y-3 my-6 max-h-[50vh] overflow-y-auto pr-1 scroll-smooth scrollbar-thin scrollbar-thumb-[#00FFC4]/30 scrollbar-track-gray-900">
        {question.options.map((option, index) => (
          <motion.button
            key={option}
            className={cn(
              "w-full text-left p-3 rounded-lg border transition-colors flex items-center",
              selectedOptions.includes(option) 
                ? "bg-[#00FFC4]/10 border-[#00FFC4] text-white" 
                : "bg-gray-900/50 border-gray-700 text-gray-300 hover:bg-gray-800"
            )}
            onClick={() => onOptionClick(option)}
            whileTap={{ scale: 0.98 }}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.2, delay: index * 0.03 }}
          >
            <div className="flex items-center">
              <div className={cn(
                "w-5 h-5 rounded-full border mr-3 flex items-center justify-center",
                selectedOptions.includes(option) 
                  ? "border-[#00FFC4] bg-[#00FFC4]" 
                  : "border-gray-500"
              )}>
                {selectedOptions.includes(option) && (
                  <CheckCircle className="w-3 h-3 text-black" />
                )}
              </div>
              <span>{option}</span>
            </div>
          </motion.button>
        ))}
      </div>
    </motion.div>
  );
};

export default QuestionDisplay;
