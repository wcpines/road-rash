NB: This project is not maintained 

There doesn't appear to be a way to export activities from Strava other than GPX/TCX data files. I prefer a simple history of my runs as a CSV, so I threw together something that makes the necessary API calls to retrieve the activities and email them to you as a CSV.

The CSV includes the following fields when available:

- name
- miles
- duration
- pace
- date
- time
- shoe
- shoe-miles
- description

Though complete, this site is still somewhat experimental.  Strava has fairly strict rate limiting, which I do my best to handle by queueing export requests and waiting 15 minutes when the limits are reached before retrying the API call.  This still may not be enough to handle a large number of concurrent export requests.  Also please note that this does not export cycling data but I'd certainly consider adding an option to export cycling history (separately) if there is demand.  PRs are also welcome.
