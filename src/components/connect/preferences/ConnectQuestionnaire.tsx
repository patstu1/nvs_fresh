
import React, { useState, useEffect, useCallback } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Button } from '@/components/ui/button';
import { ArrowRight, ArrowLeft, ChevronLeft, ChevronRight } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { toast } from '@/hooks/use-toast';
import { ScrollArea } from '@/components/ui/scroll-area';
import { QuestionnaireProps } from './types/questionnaireTypes';
import { questionsData } from './data/questionsData';
import QuestionDisplay from './components/QuestionDisplay';
import QuestionnaireProgress from './components/QuestionnaireProgress';

const PERSISTENCE_KEY = 'connect-questionnaire-answers';

const ConnectQuestionnaire: React.FC<QuestionnaireProps> = ({ 
  onComplete, 
  onSkip, 
  autoStart = true,
  initialQuestionIndex = 0,
  persistenceKey = PERSISTENCE_KEY
}) => {
  const [isVisible, setIsVisible] = useState(autoStart);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(initialQuestionIndex);
  const [answers, setAnswers] = useState<Record<string, string | string[]>>({});
  const [selectedOptions, setSelectedOptions] = useState<string[]>([]);
  const [isAnimating, setIsAnimating] = useState(false);

  // Load saved answers from localStorage
  useEffect(() => {
    try {
      const savedAnswers = localStorage.getItem(persistenceKey);
      if (savedAnswers) {
        const parsedAnswers = JSON.parse(savedAnswers);
        setAnswers(parsedAnswers);
      }
    } catch (e) {
      console.error('Error loading saved questionnaire answers:', e);
    }
  }, [persistenceKey]);

  // Set selected options for current question
  useEffect(() => {
    const currentQuestion = questionsData[currentQuestionIndex];
    if (currentQuestion) {
      const existingAnswer = answers[currentQuestion.id];
      if (existingAnswer) {
        setSelectedOptions(Array.isArray(existingAnswer) ? existingAnswer : [existingAnswer]);
      } else {
        setSelectedOptions([]);
      }
    }
  }, [currentQuestionIndex, answers]);

  const currentQuestion = questionsData[currentQuestionIndex];

  const handleOptionClick = useCallback((option: string) => {
    if (currentQuestion.allowMultiple) {
      setSelectedOptions(prev => {
        if (prev.includes(option)) {
          return prev.filter(item => item !== option);
        }
        return [...prev, option];
      });
    } else {
      setSelectedOptions([option]);
    }
  }, [currentQuestion]);

  const saveCurrentAnswer = useCallback(() => {
    if (selectedOptions.length === 0) return false;
    
    const newAnswers = {
      ...answers,
      [currentQuestion.id]: currentQuestion.allowMultiple ? selectedOptions : selectedOptions[0]
    };
    
    setAnswers(newAnswers);
    localStorage.setItem(persistenceKey, JSON.stringify(newAnswers));
    return true;
  }, [answers, currentQuestion, persistenceKey, selectedOptions]);

  const handleNext = useCallback(() => {
    if (isAnimating) return;
    
    const saved = saveCurrentAnswer();
    if (!saved) {
      toast({
        title: "Selection Required",
        description: "Please select at least one option to continue",
        variant: "destructive"
      });
      return;
    }

    setIsAnimating(true);
    
    if (currentQuestionIndex < questionsData.length - 1) {
      setTimeout(() => {
        setCurrentQuestionIndex(prev => prev + 1);
        setIsAnimating(false);
      }, 300);
    } else {
      handleComplete();
    }
  }, [isAnimating, saveCurrentAnswer, currentQuestionIndex]);

  const handleBack = useCallback(() => {
    if (isAnimating || currentQuestionIndex === 0) return;
    
    setIsAnimating(true);
    saveCurrentAnswer();
    
    setTimeout(() => {
      setCurrentQuestionIndex(prev => prev - 1);
      setIsAnimating(false);
    }, 300);
  }, [isAnimating, currentQuestionIndex, saveCurrentAnswer]);

  const handleComplete = () => {
    saveCurrentAnswer();
    localStorage.setItem('connect-questionnaire-completed', 'true');
    onComplete(answers);
    setIsVisible(false);
    toast({
      title: "Preferences Saved",
      description: "Your answers have been saved and will improve your matching experience",
    });
  };

  const handleSkip = () => {
    if (onSkip) {
      onSkip();
    }
    setIsVisible(false);
  };

  const handleKeyNavigation = useCallback((e: KeyboardEvent) => {
    if (e.key === 'ArrowRight' || e.key === 'Enter') {
      handleNext();
    } else if (e.key === 'ArrowLeft') {
      handleBack();
    }
  }, [handleNext, handleBack]);

  useEffect(() => {
    window.addEventListener('keydown', handleKeyNavigation);
    return () => {
      window.removeEventListener('keydown', handleKeyNavigation);
    };
  }, [handleKeyNavigation]);

  if (!isVisible) return null;

  return (
    <motion.div 
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md p-4"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
    >
      <Card className="max-w-md w-full bg-black border border-[#222] p-6 shadow-xl rounded-xl relative overflow-hidden">
        <div className="absolute inset-0 pointer-events-none z-0 opacity-10">
          <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxkZWZzPjxwYXR0ZXJuIGlkPSJncmlkIiB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiPjxwYXRoIGQ9Ik0gMjAgMCBMIDAgMCAwIDIwIiBmaWxsPSJub25lIiBzdHJva2U9IiMwMEZGQ0MiIHN0cm9rZS13aWR0aD0iMC4yIi8+PC9wYXR0ZXJuPjwvZGVmcz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ1cmwoI2dyaWQpIiAvPjwvc3ZnPg==')] opacity-20"></div>
          <motion.div 
            className="absolute top-0 left-0 right-0 h-[1px] bg-[#00FFCC]/40"
            animate={{ 
              y: ["0%", "100%", "0%"],
            }}
            transition={{ 
              repeat: Infinity, 
              duration: 8,
              ease: "linear"
            }}
          />
        </div>
        
        <div className="relative z-10">
          <QuestionnaireProgress 
            currentQuestionIndex={currentQuestionIndex}
            totalQuestions={questionsData.length}
          />

          <ScrollArea className="h-[400px] pr-4 -mr-4">
            <AnimatePresence mode="wait">
              <QuestionDisplay
                key={currentQuestionIndex}
                question={currentQuestion}
                selectedOptions={selectedOptions}
                onOptionClick={handleOptionClick}
              />
            </AnimatePresence>
          </ScrollArea>

          <div className="flex justify-between mt-6">
            <Button 
              variant="outline" 
              onClick={handleBack}
              disabled={currentQuestionIndex === 0 || isAnimating}
              className="border-gray-700 text-gray-300 hover:bg-gray-800"
            >
              <ArrowLeft className="mr-2 h-4 w-4" /> Back
            </Button>
            
            <div className="flex gap-2">
              {currentQuestionIndex === 0 && (
                <Button
                  variant="ghost"
                  onClick={handleSkip}
                  className="text-gray-400 hover:text-white"
                >
                  Skip
                </Button>
              )}
              
              <Button 
                onClick={handleNext}
                disabled={selectedOptions.length === 0 || isAnimating}
                className="bg-[#00FFC4] hover:bg-[#00FFC4]/80 text-black"
              >
                {currentQuestionIndex === questionsData.length - 1 ? 'Finish' : 'Next'} 
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </div>
          </div>
          
          {/* Question navigation indicators */}
          <div className="flex justify-center mt-6 gap-1 overflow-hidden">
            {questionsData.length > 10 ? (
              <>
                <button 
                  onClick={handleBack} 
                  disabled={currentQuestionIndex === 0} 
                  className="text-[#00FFC4] disabled:text-gray-600"
                >
                  <ChevronLeft className="h-5 w-5" />
                </button>
                <div className="flex items-center space-x-1">
                  {Array.from({ length: Math.min(5, questionsData.length) }).map((_, i) => {
                    // Show first 2 dots, current dot in middle, and last 2 dots
                    let dotIndex: number;
                    const mid = Math.floor(Math.min(5, questionsData.length) / 2);
                    
                    if (currentQuestionIndex < 2) {
                      dotIndex = i;
                    } else if (currentQuestionIndex >= questionsData.length - 2) {
                      dotIndex = questionsData.length - Math.min(5, questionsData.length) + i;
                    } else {
                      dotIndex = currentQuestionIndex - mid + i;
                    }
                    
                    return (
                      <div
                        key={i}
                        className={`h-2 w-2 rounded-full transition-all duration-300 ${
                          dotIndex === currentQuestionIndex 
                            ? "bg-[#00FFC4]" 
                            : "bg-gray-700"
                        }`}
                      />
                    );
                  })}
                </div>
                <button 
                  onClick={handleNext} 
                  disabled={currentQuestionIndex === questionsData.length - 1} 
                  className="text-[#00FFC4] disabled:text-gray-600"
                >
                  <ChevronRight className="h-5 w-5" />
                </button>
              </>
            ) : (
              questionsData.map((_, i) => (
                <div
                  key={i}
                  className={`h-2 w-2 rounded-full transition-all duration-300 ${
                    i === currentQuestionIndex 
                      ? "bg-[#00FFC4]" 
                      : "bg-gray-700"
                  }`}
                />
              ))
            )}
          </div>
        </div>
      </Card>
    </motion.div>
  );
};

export default ConnectQuestionnaire;
