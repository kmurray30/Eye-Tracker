# Eye-Tracker
Tracks user's eye movement while looking at the screen to determine where user is looking and move cursor to user's point of focus

This uses the Matlab image analysis API to locate your pupils and eyes as they move, with a live stream being recorded from your webcam. A live video is played highlighting the movement of your pupils and your eyes. It uses this relationship to determine where you are looking on the screen, and moves a point on a graph to that point.

Instructions to use:
\n0) You may need to set up your webcam to allow Matlab to access it. Instructions can be found online.
1) Run calibration.m and follow the on-screen instruction. You must take pictures with your head still and looking at each of the four corners so that the program has a baseline to compare to
2) Run finalTracking.m to see it in action. Red circles will appear around your pupils and green boxes around your eyes, and the point on the graph should be within a 1-inch range of where you are looking. Its accuracy can be improved.

Ideas for improvement:
-Have program take control of mouse
-Blinking causes a click
-Take average of two eyes to increase accuracy
-Allow real-time calibration to update it when it starts to lose accuracy
-Implement machine learning algorithm to learn where point of focus truly is, instead of soleley relying on four corner calibration
