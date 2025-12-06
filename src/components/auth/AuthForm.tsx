
import React, { memo } from 'react';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import YoBroLogo from '@/components/YoBroLogo';
import SignInForm from './SignInForm';
import SignUpForm from './SignUpForm';

interface AuthFormProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
  isLoading: boolean;
  handleSignIn: (e: React.FormEvent) => Promise<void>;
  handleSignUp: (e: React.FormEvent) => Promise<void>;
  email: string;
  setEmail: (email: string) => void;
  password: string;
  setPassword: (password: string) => void;
  fullName: string;
  setFullName: (fullName: string) => void;
}

const AuthForm: React.FC<AuthFormProps> = memo(({
  activeTab,
  setActiveTab,
  isLoading,
  handleSignIn,
  handleSignUp,
  email,
  setEmail,
  password,
  setPassword,
  fullName,
  setFullName
}) => {
  // Access the Icon components directly
  const SignInIcon = SignInForm.Icon;
  const SignUpIcon = SignUpForm.Icon;

  return (
    <div className="min-h-screen bg-yobro-dark flex flex-col items-center justify-center p-4">
      <div className="mb-8">
        <YoBroLogo size="large" />
      </div>
      
      <Card className="w-full max-w-md bg-black border border-[#C2FFE6]/30">
        <CardHeader>
          <CardTitle className="text-[#E6FFF4] text-xl text-center">Welcome to YO BRO</CardTitle>
          <CardDescription className="text-center text-[#E6FFF4]/70">
            Sign in or create an account to continue
          </CardDescription>
        </CardHeader>
        
        <CardContent>
          <Tabs defaultValue={activeTab} value={activeTab} onValueChange={setActiveTab} className="w-full">
            <TabsList className="grid grid-cols-2 mb-6 bg-transparent border rounded-md border-[#C2FFE6]/30">
              <TabsTrigger 
                value="signin" 
                className="data-[state=active]:bg-[#C2FFE6] data-[state=active]:text-black rounded-sm flex items-center gap-2"
              >
                {SignInIcon && <SignInIcon />} Sign In
              </TabsTrigger>
              <TabsTrigger 
                value="signup" 
                className="data-[state=active]:bg-[#C2FFE6] data-[state=active]:text-black rounded-sm flex items-center gap-2"
              >
                {SignUpIcon && <SignUpIcon />} Sign Up
              </TabsTrigger>
            </TabsList>
            
            <TabsContent value="signin">
              <SignInForm 
                email={email}
                setEmail={setEmail}
                password={password}
                setPassword={setPassword}
                isLoading={isLoading}
                onSubmit={handleSignIn}
              />
            </TabsContent>
            
            <TabsContent value="signup">
              <SignUpForm 
                email={email}
                setEmail={setEmail}
                password={password}
                setPassword={setPassword}
                fullName={fullName}
                setFullName={setFullName}
                isLoading={isLoading}
                onSubmit={handleSignUp}
              />
            </TabsContent>
          </Tabs>
        </CardContent>
        
        <CardFooter className="flex flex-col space-y-2">
          <p className="text-sm text-[#E6FFF4]/50 text-center">
            By continuing, you agree to our <a href="/terms-of-service" className="text-[#C2FFE6] underline">Terms of Service</a> and <a href="/privacy-policy" className="text-[#C2FFE6] underline">Privacy Policy</a>
          </p>
        </CardFooter>
      </Card>
    </div>
  );
});

AuthForm.displayName = 'AuthForm';

export default AuthForm;
