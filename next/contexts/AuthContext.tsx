import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { useRouter } from 'next/router'

interface User {
  id: number
  name: string
  email: string
}

interface AuthContextType {
  user: User | null
  token: string | null
  loading: boolean
  login: (email: string, password: string) => Promise<boolean>
  register: (name: string, email: string, password: string, password_confirmation: string) => Promise<boolean>
  logout: () => void
  checkAuth: () => boolean
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}

interface AuthProviderProps {
  children: ReactNode
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null)
  const [token, setToken] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    // Check for existing auth on mount
    checkAuth()
  }, [])

  const checkAuth = (): boolean => {
    const storedToken = localStorage.getItem('auth_token')
    const storedUser = localStorage.getItem('user')

    if (storedToken && storedUser) {
      try {
        const userObj = JSON.parse(storedUser)
        setToken(storedToken)
        setUser(userObj)
        setLoading(false)
        return true
      } catch (err) {
        // Invalid stored data, clear it
        localStorage.removeItem('auth_token')
        localStorage.removeItem('user')
        setToken(null)
        setUser(null)
        setLoading(false)
        return false
      }
    } else {
      setLoading(false)
      return false
    }
  }

  const login = async (email: string, password: string): Promise<boolean> => {
    setLoading(true)
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'}/api/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: JSON.stringify({ email, password })
      })

      const data = await response.json()

      if (response.ok && data.success) {
        const { token: authToken, user: userData } = data.data
        
        // Store in localStorage
        localStorage.setItem('auth_token', authToken)
        localStorage.setItem('user', JSON.stringify(userData))
        
        // Update state
        setToken(authToken)
        setUser(userData)
        setLoading(false)
        
        return true
      } else {
        setLoading(false)
        return false
      }
    } catch (err) {
      console.error('Login error:', err)
      setLoading(false)
      return false
    }
  }

  const register = async (name: string, email: string, password: string, password_confirmation: string): Promise<boolean> => {
    setLoading(true)
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'}/api/auth/register`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: JSON.stringify({ name, email, password, password_confirmation })
      })

      const data = await response.json()

      if (response.ok && data.success) {
        const { token: authToken, user: userData } = data.data
        
        // Store in localStorage
        localStorage.setItem('auth_token', authToken)
        localStorage.setItem('user', JSON.stringify(userData))
        
        // Update state
        setToken(authToken)
        setUser(userData)
        setLoading(false)
        
        return true
      } else {
        setLoading(false)
        return false
      }
    } catch (err) {
      console.error('Registration error:', err)
      setLoading(false)
      return false
    }
  }

  const logout = async () => {
    try {
      // Call logout API if token exists
      if (token) {
        await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'}/api/auth/logout`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Accept': 'application/json',
          }
        })
      }
    } catch (err) {
      console.error('Logout API error:', err)
    } finally {
      // Clear local storage and state
      localStorage.removeItem('auth_token')
      localStorage.removeItem('user')
      setToken(null)
      setUser(null)
      
      // Redirect to home
      router.push('/')
    }
  }

  const value: AuthContextType = {
    user,
    token,
    loading,
    login,
    register,
    logout,
    checkAuth
  }

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  )
}
