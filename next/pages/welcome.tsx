import { useState, useEffect } from 'react'
import Head from 'next/head'
import Link from 'next/link'
import { ProtectedRoute } from '../components/ProtectedRoute'
import { Navigation } from '../components/Navigation'
import { useAuth } from '../contexts/AuthContext'

interface UserStats {
  total_users: number
  new_users_today: number
  active_users: number
}

export default function Welcome() {
  const { user, token, logout } = useAuth()
  const [stats, setStats] = useState<UserStats | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (user && token) {
      fetchUserStats()
    }
  }, [user, token])

  const fetchUserStats = async () => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'}/api/users/stats`, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Accept': 'application/json',
        }
      })

      if (response.ok) {
        const data = await response.json()
        setStats(data.data)
      }
    } catch (err) {
      console.error('Failed to fetch stats:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleLogout = async () => {
    logout()
  }



  return (
    <ProtectedRoute>
      <Head>
        <title>Welcome - Laravel + Next.js App</title>
        <meta name="description" content="Welcome to your dashboard" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      
      <Navigation />
              <main className="min-h-screen bg-gradient-to-br from-purple-50 to-pink-100">

        {/* Main Content */}
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Welcome Hero Section */}
          <div className="text-center mb-12">
            <div className="bg-white rounded-2xl shadow-xl p-8 mb-8">
              <h1 className="text-4xl font-bold text-gray-900 mb-4">
                Welcome back, {user?.name || 'User'}! 👋
              </h1>
              <p className="text-xl text-gray-600 mb-6">
                You're successfully logged into your Laravel + Next.js application
              </p>
              <div className="inline-flex items-center px-4 py-2 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                <svg className="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
                Authenticated Successfully
              </div>
            </div>
          </div>

          {/* User Info & Stats Grid */}
          <div className="grid md:grid-cols-2 gap-8 mb-12">
            {/* User Information Card */}
            <div className="bg-white rounded-2xl shadow-xl p-8">
              <h2 className="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
                <svg className="w-6 h-6 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
                Your Profile
              </h2>
              <div className="space-y-4">
                <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <span className="text-gray-600 font-medium">User ID:</span>
                  <span className="text-gray-900 font-mono">#{user?.id || 'N/A'}</span>
                </div>
                <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <span className="text-gray-600 font-medium">Name:</span>
                  <span className="text-gray-900">{user?.name || 'N/A'}</span>
                </div>
                <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                  <span className="text-gray-600 font-medium">Email:</span>
                  <span className="text-gray-900">{user?.email || 'N/A'}</span>
                </div>
              </div>
            </div>

            {/* System Stats Card */}
            <div className="bg-white rounded-2xl shadow-xl p-8">
              <h2 className="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
                <svg className="w-6 h-6 mr-2 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
                System Statistics
              </h2>
              {loading ? (
                <div className="text-center py-8">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600 mx-auto mb-4"></div>
                  <p className="text-gray-600">Loading stats...</p>
                </div>
              ) : stats ? (
                <div className="space-y-4">
                  <div className="flex items-center justify-between p-4 bg-green-50 rounded-lg">
                    <span className="text-gray-600 font-medium">Total Users:</span>
                    <span className="text-green-900 font-bold text-lg">{stats.total_users}</span>
                  </div>
                  <div className="flex items-center justify-between p-4 bg-blue-50 rounded-lg">
                    <span className="text-gray-600 font-medium">New Today:</span>
                    <span className="text-blue-900 font-bold text-lg">{stats.new_users_today}</span>
                  </div>
                  <div className="flex items-center justify-between p-4 bg-purple-50 rounded-lg">
                    <span className="text-gray-600 font-medium">Active Users:</span>
                    <span className="text-purple-900 font-bold text-lg">{stats.active_users}</span>
                  </div>
                </div>
              ) : (
                <div className="text-center py-8 text-gray-500">
                  <p>Stats unavailable</p>
                </div>
              )}
            </div>
          </div>

          {/* Quick Actions Grid */}
          <div className="grid md:grid-cols-3 gap-6 mb-12">
            <Link href="/" className="group">
              <div className="bg-white rounded-2xl shadow-xl p-6 hover:shadow-2xl transition-all duration-300 group-hover:scale-105">
                <div className="text-center">
                  <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4 group-hover:bg-blue-200 transition-colors duration-300">
                    <svg className="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                    </svg>
                  </div>
                  <h3 className="text-lg font-semibold text-gray-800 mb-2">Go Home</h3>
                  <p className="text-gray-600">Return to the main dashboard</p>
                </div>
              </div>
            </Link>

            <Link href="http://localhost:8000/api/documentation" target="_blank" className="group">
              <div className="bg-white rounded-2xl shadow-xl p-6 hover:shadow-2xl transition-all duration-300 group-hover:scale-105">
                <div className="text-center">
                  <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4 group-hover:bg-green-200 transition-colors duration-300">
                    <svg className="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                  </div>
                  <h3 className="text-lg font-semibold text-gray-800 mb-2">API Docs</h3>
                  <p className="text-gray-600">View Swagger documentation</p>
                </div>
              </div>
            </Link>

            <Link href="http://localhost:8080" target="_blank" className="group">
              <div className="bg-white rounded-2xl shadow-xl p-6 hover:shadow-2xl transition-all duration-300 group-hover:scale-105">
                <div className="text-center">
                  <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4 group-hover:bg-purple-200 transition-colors duration-300">
                    <svg className="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
                    </svg>
                  </div>
                  <h3 className="text-lg font-semibold text-gray-800 mb-2">Database</h3>
                  <p className="text-gray-600">Manage with phpMyAdmin</p>
                </div>
              </div>
            </Link>
          </div>

          {/* Authentication Info */}
          <div className="bg-white rounded-2xl shadow-xl p-8">
            <h2 className="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
              <svg className="w-6 h-6 mr-2 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
              </svg>
              Authentication Status
            </h2>
            <div className="grid md:grid-cols-2 gap-6">
              <div className="p-4 bg-green-50 rounded-lg border border-green-200">
                <h3 className="font-medium text-green-800 mb-2">✅ API Token</h3>
                <p className="text-green-700 text-sm">
                  Your authentication token is valid and working. You can access all protected API endpoints.
                </p>
              </div>
              <div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
                <h3 className="font-medium text-blue-800 mb-2">🔐 Session Active</h3>
                <p className="text-blue-700 text-sm">
                  You're currently logged in and can access protected routes and user data.
                </p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </ProtectedRoute>
  )
}
