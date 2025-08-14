import { useState, useEffect } from 'react'
import Head from 'next/head'
import { Navigation } from '../components/Navigation'
import { useAuth } from '../contexts/AuthContext'

interface User {
  id: number
  name: string
  email: string
  created_at: string
}

export default function Home() {
  const { user } = useAuth()
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'}/api/users`)
      if (response.ok) {
        const data = await response.json()
        setUsers(data.data || [])
      } else {
        setError('Failed to fetch users')
      }
    } catch (err) {
      setError('Error connecting to API')
    } finally {
      setLoading(false)
    }
  }

  return (
    <>
      <Head>
        <title>Laravel + Next.js Full Stack App</title>
        <meta name="description" content="Full stack application with Laravel API and Next.js frontend" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Navigation />
      <main className="min-h-screen bg-gray-50">
        <div className="container mx-auto px-4 py-8">
          <div className="text-center mb-8">
            <h1 className="text-4xl font-bold text-gray-900 mb-4">
              🚀 Laravel + Next.js Full Stack (Dev Mode Active!)
            </h1>
            <p className="text-xl text-gray-600 mb-6">
              Modern full-stack development with Laravel API and Next.js frontend
            </p>
            
            {/* Authentication Status */}
            {user ? (
              <div className="inline-flex items-center px-6 py-3 bg-green-100 text-green-800 rounded-full text-lg font-medium mb-4">
                <svg className="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
                Welcome back, {user.name}! You're logged in.
              </div>
            ) : (
              <div className="inline-flex items-center px-6 py-3 bg-blue-100 text-blue-800 rounded-full text-lg font-medium mb-4">
                <svg className="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.986 5.986 0 0010 16a5.986 5.986 0 004.546-2.084A5 5 0 0010 11z" clipRule="evenodd" />
                </svg>
                Get started by creating an account or signing in
              </div>
            )}
            
            {/* Quick Actions */}
            <div className="flex flex-wrap justify-center gap-4">
              {user ? (
                <>
                  <a
                    href="/welcome"
                    className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors duration-200 font-medium"
                  >
                    Go to Dashboard
                  </a>
                  <a
                    href="http://localhost:8000/api/documentation"
                    target="_blank"
                    className="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition-colors duration-200 font-medium"
                  >
                    View API Docs
                  </a>
                </>
              ) : (
                <>
                  <a
                    href="/login"
                    className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors duration-200 font-medium"
                  >
                    Sign In
                  </a>
                  <a
                    href="/register"
                    className="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition-colors duration-200 font-medium"
                  >
                    Create Account
                  </a>
                </>
              )}
            </div>
          </div>

          <div className="grid md:grid-cols-2 gap-8 mb-8">
            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-2xl font-semibold text-gray-800 mb-4">🔧 Backend (Laravel)</h2>
              <ul className="text-gray-600 space-y-2">
                <li>• RESTful API endpoints</li>
                <li>• MySQL database integration</li>
                <li>• Authentication & authorization</li>
                <li>• Database migrations & seeders</li>
                <li>• API resource controllers</li>
              </ul>
            </div>

            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-2xl font-semibold text-gray-800 mb-4">⚡ Frontend (Next.js)</h2>
              <ul className="text-gray-600 space-y-2">
                <li>• React 18 with TypeScript</li>
                <li>• Server-side rendering (SSR)</li>
                <li>• API integration with Laravel</li>
                <li>• Responsive design</li>
                <li>• Modern development experience</li>
              </ul>
            </div>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-md">
            <h2 className="text-2xl font-semibold text-gray-800 mb-4">👥 Users from Laravel API</h2>
            {loading && (
              <div className="text-center py-8">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                <p className="mt-4 text-gray-600">Loading users...</p>
              </div>
            )}
            
            {error && (
              <div className="text-center py-8">
                <div className="text-red-600 mb-4">⚠️ {error}</div>
                <p className="text-gray-600">Make sure your Laravel API is running and has users data.</p>
              </div>
            )}

            {!loading && !error && users.length === 0 && (
              <div className="text-center py-8">
                <p className="text-gray-600">No users found. Create some users in your Laravel application first.</p>
              </div>
            )}

            {!loading && !error && users.length > 0 && (
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created</th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {users.map((user) => (
                      <tr key={user.id}>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{user.id}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{user.name}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{user.email}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {new Date(user.created_at).toLocaleDateString()}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          <div className="mt-8 text-center text-gray-600">
            <p>Check out the <a href="http://localhost:8080" className="text-blue-600 hover:underline">phpMyAdmin</a> to manage your MySQL database</p>
          </div>
        </div>
      </main>
    </>
  )
}
