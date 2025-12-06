
import React from 'react';
import { Navigate } from 'react-router-dom';

const Auth: React.FC = () => {
  // Simply redirect to home page since we're removing auth
  return <Navigate to="/" replace />;
};

export default Auth;
