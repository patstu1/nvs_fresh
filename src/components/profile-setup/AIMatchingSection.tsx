
import React from 'react';
import { useFormContext } from 'react-hook-form';
import { Checkbox } from '@/components/ui/checkbox';
import { Label } from '@/components/ui/label';
import { Button } from '@/components/ui/button';
import { Shield, Sparkles, Lock, Eye } from 'lucide-react';

interface AIMatchingSectionProps {
  isProcessing: boolean;
  onSubmit: () => void;
}

const AIMatchingSection: React.FC<AIMatchingSectionProps> = ({ 
  isProcessing,
  onSubmit
}) => {
  const { register, setValue, watch } = useFormContext();
  const allowAiAnalysis = watch('allowAiAnalysis');
  
  const handleToggleAiAnalysis = (checked: boolean) => {
    setValue('allowAiAnalysis', checked, { shouldValidate: true });
  };

  return (
    <div className="space-y-6">
      <div className="bg-[#1A1A1A] border border-[#E6FFF4]/20 rounded-lg p-5">
        <div className="flex items-start gap-4 mb-5">
          <div className="p-2 bg-[#E6FFF4]/10 rounded-md">
            <Sparkles className="h-6 w-6 text-[#E6FFF4]" />
          </div>
          <div>
            <h3 className="text-lg font-semibold text-[#E6FFF4] mb-1">AI-Powered Matching</h3>
            <p className="text-[#E6FFF4]/70 text-sm">
              Our advanced AI can analyze your profile and preferences to find the best possible matches for you.
            </p>
          </div>
        </div>
        
        <div className="space-y-4">
          <div className="flex gap-2 items-start">
            <Shield className="h-5 w-5 text-[#E6FFF4]/80 mt-0.5" />
            <p className="text-sm text-[#E6FFF4]/80">
              We use ethical AI that respects your privacy and only analyzes the data you consent to share.
            </p>
          </div>
          
          <div className="flex gap-2 items-start">
            <Lock className="h-5 w-5 text-[#E6FFF4]/80 mt-0.5" />
            <p className="text-sm text-[#E6FFF4]/80">
              Your data is encrypted and never shared with third parties.
            </p>
          </div>
          
          <div className="flex gap-2 items-start">
            <Eye className="h-5 w-5 text-[#E6FFF4]/80 mt-0.5" />
            <p className="text-sm text-[#E6FFF4]/80">
              You can revoke access at any time through your profile settings.
            </p>
          </div>
        </div>
      </div>
      
      <div className="flex items-start space-x-2 mt-8">
        <Checkbox 
          id="ai-analysis" 
          checked={allowAiAnalysis}
          onCheckedChange={handleToggleAiAnalysis}
          className="data-[state=checked]:bg-[#E6FFF4] data-[state=checked]:text-black border-[#E6FFF4]"
        />
        <div className="grid gap-1.5 leading-none">
          <Label
            htmlFor="ai-analysis"
            className="text-[#E6FFF4] font-medium"
          >
            Enable AI-Powered Matching
          </Label>
          <p className="text-sm text-[#E6FFF4]/70">
            I consent to having my profile analyzed by AI to improve my matches.
          </p>
        </div>
      </div>
      
      <div className="mt-6">
        <Button
          type="button"
          onClick={onSubmit}
          disabled={isProcessing}
          className="w-full bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90 flex items-center justify-center gap-2 h-12"
        >
          {isProcessing ? (
            <>Processing...</>
          ) : (
            <>Complete Profile Setup</>
          )}
        </Button>
      </div>
    </div>
  );
};

export default AIMatchingSection;
