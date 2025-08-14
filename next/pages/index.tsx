import { useState, useEffect } from 'react'
import Head from 'next/head'

interface User {
  id: number
  name: string
  email: string
  created_at: string
}

export default function Home() {
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/users`)
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
      <main className="min-h-screen bg-gray-50">
        <div className="container mx-auto px-4 py-8">
          <div className="text-center mb-8">
            <h1 className="text-4xl font-bold text-gray-900 mb-4">
              🚀 Laravel + Next.js Full Stack
            </h1>
            <p className="text-xl text-gray-600">
              Modern full-stack development with Laravel API and Next.js frontend
            </p>
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
