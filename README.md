<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome Page</title>
    <style>
        /* CSS Styles */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }

        .welcome-container {
            display: flex;
            justify-content: space-around;
            align-items: center;
            width: 80%;
            max-width: 1200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .welcome-content {
            max-width: 50%;
        }

        .welcome-content h1 {
            font-size: 3rem;
            margin-bottom: 20px;
        }

        .welcome-content p {
            font-size: 1.2rem;
            margin-bottom: 30px;
        }

        .welcome-content .buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap; /* Allow buttons to wrap on smaller screens */
        }

        .welcome-content button {
            background: #ff6f61;
            border: none;
            padding: 15px 30px;
            font-size: 1rem;
            color: white;
            border-radius: 50px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .welcome-content button:hover {
            background: #ff3b2f;
        }

        .welcome-image img {
            max-width: 100%;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        @media (max-width: 768px) {
            .welcome-container {
                flex-direction: column;
                text-align: center;
            }

            .welcome-content {
                max-width: 100%;
                margin-bottom: 30px;
            }

            .welcome-image img {
                max-width: 80%;
            }

            .welcome-content .buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <!-- HTML Content -->
    <div class="welcome-container">
        <div class="welcome-content">
            <h1>Welcome to Our Platform</h1>
            <p>Your journey starts here. Explore, learn, and grow with us.</p>
            <div class="buttons">
                <button id="cevediPostsBtn">Go to Cevedi Posts</button>
                <button id="keyPageBtn">Go to Key Page</button>
                <button id="ticTacToeBtn">Tic Tac Toe</button>
                <button id="pvmBtn">PVM</button>
            </div>
        </div>
        <div class="welcome-image">
            <!-- Updated image source -->
            <img src="https://t4.ftcdn.net/jpg/03/41/47/73/360_F_341477352_FPoRvWnWWqdzVFnIWn3on34gYWaSEX2K.jpg" alt="Welcome Image">
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // JavaScript to open links in a new tab
        document.getElementById('cevediPostsBtn').addEventListener('click', function() {
            window.open('https://thebware.github.io/-/CevediPosts.html', '_blank');
        });

        document.getElementById('keyPageBtn').addEventListener('click', function() {
            window.open('https://thebware.github.io/-/key.html', '_blank');
        });

        document.getElementById('ticTacToeBtn').addEventListener('click', function() {
            window.open('https://thebware.github.io/-/TicTacToe.html', '_blank');
        });

        document.getElementById('pvmBtn').addEventListener('click', function() {
            window.open('https://thebware.github.io/-/PVM.html', '_blank');
        });
    </script>
</body>
</html>
