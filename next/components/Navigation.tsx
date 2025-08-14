import Link from 'next/link'
import { useAuth } from '../contexts/AuthContext'

export const Navigation: React.FC = () => {
  const { user, logout } = useAuth()

  const handleLogout = () => {
    logout()
  }

  return (
    <nav className="bg-white shadow-sm border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo/Brand */}
          <div className="flex items-center">
            <Link href="/" className="text-xl font-semibold text-gray-900 hover:text-blue-600 transition-colors duration-200">
              🚀 Laravel + Next.js App
            </Link>
          </div>

          {/* Navigation Links */}
          <div className="hidden md:flex items-center space-x-8">
            <Link 
              href="/" 
              className="text-gray-700 hover:text-blue-600 transition-colors duration-200"
            >
              Home
            </Link>
            
            {user ? (
              <>
                <Link 
                  href="/welcome" 
                  className="text-gray-700 hover:text-blue-600 transition-colors duration-200"
                >
                  Dashboard
                </Link>
                <Link 
                  href="http://localhost:8000/api/documentation" 
                  target="_blank"
                  className="text-gray-700 hover:text-blue-600 transition-colors duration-200"
                >
                  API Docs
                </Link>
                <Link 
                  href="http://localhost:8080" 
                  target="_blank"
                  className="text-gray-700 hover:text-blue-600 transition-colors duration-200"
                >
                  Database
                </Link>
              </>
            ) : (
              <>
                <Link 
                  href="http://localhost:8000/api/documentation" 
                  target="_blank"
                  className="text-gray-700 hover:text-blue-600 transition-colors duration-200"
                >
                  API Docs
                </Link>
                <Link 
                  href="http://localhost:8080" 
                  target="_blank"
                  className="text-gray-700 hover:text-blue-600 transition-colors duration-200"
                >
                  Database
                </Link>
              </>
            )}
          </div>

          {/* Auth Actions */}
          <div className="flex items-center space-x-4">
            {user ? (
              <div className="flex items-center space-x-4">
                <span className="text-gray-700 text-sm">
                  Welcome, {user.name}!
                </span>
                <button
                  onClick={handleLogout}
                  className="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors duration-200 text-sm"
                >
                  Logout
                </button>
              </div>
            ) : (
              <div className="flex items-center space-x-4">
                <Link 
                  href="/login"
                  className="text-gray-700 hover:text-blue-600 transition-colors duration-200 text-sm"
                >
                  Sign In
                </Link>
                <Link 
                  href="/register"
                  className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors duration-200 text-sm"
                >
                  Sign Up
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  )
}
