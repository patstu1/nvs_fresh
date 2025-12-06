
import React, { useState, useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Lock, Mail } from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';
import { toast } from '@/hooks/use-toast';

interface SignInFormProps {
  email: string;
  setEmail: (email: string) => void;
  password: string;
  setPassword: (password: string) => void;
  isLoading: boolean;
  onSubmit: (e: React.FormEvent) => Promise<void>;
}

// Create the icon component outside
const SignInIcon = () => <Lock className="w-4 h-4" />;

// Define a type for the component with Icon property
interface SignInFormWithIcon extends React.FC<SignInFormProps> {
  Icon: typeof SignInIcon;
}

const SignInForm: React.FC<SignInFormProps> = ({
  email,
  setEmail,
  password,
  setPassword,
  isLoading,
  onSubmit
}) => {
  const [forgotPasswordLoading, setForgotPasswordLoading] = useState(false);
  
  const handleForgotPassword = useCallback(async () => {
    if (!email) {
      toast({
        title: "Email required",
        description: "Please enter your email address first",
        variant: "destructive",
      });
      return;
    }
    
    try {
      setForgotPasswordLoading(true);
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/auth`,
      });
      
      if (error) {
        throw error;
      }
      
      toast({
        title: "Password reset email sent",
        description: "Check your email for a password reset link",
      });
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message || "Failed to send reset email",
        variant: "destructive",
      });
    } finally {
      setForgotPasswordLoading(false);
    }
  }, [email]);
  
  const handleEmailChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    setEmail(e.target.value);
  }, [setEmail]);
  
  const handlePasswordChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    setPassword(e.target.value);
  }, [setPassword]);
  
  return (
    <form onSubmit={onSubmit} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="email" className="text-[#E6FFF4]">Email</Label>
        <div className="relative">
          <Mail className="absolute left-3 top-2.5 h-5 w-5 text-[#C2FFE6]/70" />
          <Input
            id="email"
            type="email"
            placeholder="hello@example.com"
            value={email}
            onChange={handleEmailChange}
            required
            className="pl-10 bg-black border-[#C2FFE6]/30 text-[#E6FFF4]"
          />
        </div>
      </div>
      
      <div className="space-y-2">
        <Label htmlFor="password" className="text-[#E6FFF4]">Password</Label>
        <div className="relative">
          <Lock className="absolute left-3 top-2.5 h-5 w-5 text-[#C2FFE6]/70" />
          <Input
            id="password"
            type="password"
            placeholder="••••••••"
            value={password}
            onChange={handlePasswordChange}
            required
            className="pl-10 bg-black border-[#C2FFE6]/30 text-[#E6FFF4]"
          />
        </div>
      </div>
      
      <div className="flex justify-end">
        <button 
          type="button"
          onClick={handleForgotPassword}
          disabled={forgotPasswordLoading}
          className="text-sm text-[#C2FFE6] hover:text-[#C2FFE6]/80 transition-colors"
        >
          {forgotPasswordLoading ? 'Sending...' : 'Forgot password?'}
        </button>
      </div>
      
      <Button 
        type="submit" 
        className="w-full bg-[#C2FFE6] text-black hover:bg-[#C2FFE6]/90" 
        disabled={isLoading}
      >
        {isLoading ? 'Signing in...' : 'Sign In'}
      </Button>
    </form>
  );
};

// First create the memoized component
const MemoizedSignInForm = React.memo(SignInForm);

// Then create the final component with the Icon property
const EnhancedSignInForm = MemoizedSignInForm as unknown as SignInFormWithIcon;
EnhancedSignInForm.Icon = SignInIcon;

export default EnhancedSignInForm;
