import os, sys, time
import argparse
import requests
from requests.exceptions import HTTPError
import unicodedata
import json 
import subprocess
from dotenv import load_dotenv

parser = argparse.ArgumentParser()
parser.add_argument('-U', '--rancher_url',
            dest='RANCHER_URL',
            help='Provide the Rancher URL.',
            required=False,
            nargs='?',
            default=None
            )
parser.add_argument('-Q', '--query',
            dest='QUERY',
            help='Provide one or multiple queries. -Q followed by a query will execute checkmetrics on that query. If -Q option is followed by "-" character, checkmetrics will instead read the contents from stdin. If -Q option is followed by "@" character, checkmetrics will instead read the contents of a file.',
            required=True
            )
parser.add_argument('-T', '--rancher_token',
            dest='RANCHER_TOKEN',
            help='Provide the rancher token to authenticate to the apps.',
            required=False,
            nargs='?',
            default=None
            )
parser.add_argument('-S', '--prom_service',
            dest='PROMETHEUS_SERVICE',
            help='Provide the prometheus service.',
            required=True
            )
parser.add_argument('-N', '--prom_namespace',
            dest='PROMETHEUS_NAMESPACE',
            help='Provide the prometheus namespace.',
            required=True
            )
parser.add_argument('-D', '--duration',
            dest='DURATION',
            type=int,
            default=0,
            help='This parameter enables the use of a query range instead of the default query for the prometheus request. If you put a value such as 120, query range will be selected.',
            required=False
            )
parser.add_argument('-d', '--debug',
            dest='DEBUG_MODE',
            action='store_true',
            help='This parameter set to True enables the debug mode.',
            required=False
            )
args = parser.parse_args()

def main():
  pass

def printInfo():
  print(
""" 
RANCHER_URL or RANCHER_TOKEN variables could not be found.

If you are executing this script locally, you might need to retrieve RANCHER_URL and RANCHER_TOKEN variables. To do so, you need to install the tools get-rancher-creds and vault : 
$ toolbox install vault
$ toolbox install get-rancher-creds
# This last command will add the requested variables as environnment variables. 
$ source get-rancher-creds [ZONE] 1>/dev/null
"""
)

if args.RANCHER_URL and args.RANCHER_TOKEN:
  RANCHER_URL = args.RANCHER_URL
  RANCHER_TOKEN = args.RANCHER_TOKEN

# If the two variables are not defined, they are loaded from environnement variables. 
if not args.RANCHER_URL:
  if (os.getenv('RANCHER_URL')) and (os.getenv('RANCHER_URL') != None):
    RANCHER_URL = os.environ['RANCHER_URL']
  else:
    printInfo()
    sys.exit(1)
    
if not args.RANCHER_TOKEN:
  if (os.getenv('RANCHER_TOKEN')) and (os.getenv('RANCHER_TOKEN') != None):
    RANCHER_TOKEN = os.environ['RANCHER_TOKEN']
  else:
    printInfo()
    sys.exit(1)

def checkMetric():
  endpoint = f"{RANCHER_URL}/api/v1/namespaces/{args.PROMETHEUS_NAMESPACE}/services/{args.PROMETHEUS_SERVICE}:web/proxy/api/v1/"

  # Check the validity of the arguments. 
  try:
    integer_result = int(args.DURATION)
  except ValueError:
    print(f"Duration argument {args.DURATION} is not a valid integer.", file=sys.stderr) 
    sys.exit(1)

  # Verify that all arguments listed in args_list are of type string.
  args_list = [ RANCHER_URL, QUERY, RANCHER_TOKEN, args.PROMETHEUS_SERVICE, args.PROMETHEUS_NAMESPACE ]
  for idx, argument in enumerate(args_list):  
    if not isinstance(argument, str):
      # Print a message if the argument is not a script, then escape the script with an error. 
      print(f"Argument {argument} is not valid.", file=sys.stderr) 
      sys.exit(1)

  # If Duration argument is not 0, the request used will be a range query and not a query. 
  if args.DURATION == 0:
    prom_query = f"query?query={QUERY}"

  # If Duration is an integer, the prometheus query will be of query_range type. 
  else: 
    d1 = int(time.time())
    d2 = d1 - int(args.DURATION)
    prom_query = f"query_range?query={str(QUERY)}&start={d2}&end={d1}&step=15s"

  headers = {'Authorization': 'Bearer ' + RANCHER_TOKEN,
        'Content-Type': 'application/json'}

  # Send get request and save response as response object
  response = None
  while response is None:
    try: 
      url = endpoint + prom_query
      response = requests.get(url, headers = headers)
      jsonResponse = response.json()
      if args.DEBUG_MODE:
        print(f"INFO: url: {endpoint}")
        print("INFO: status_code: " + str(response))
        print("INFO: response: " +str(jsonResponse)) 
    except requests.HTTPError as e:
      if args.DEBUG_MODE:
        print(response.raise_for_status(), file=sys.stderr)
      print(f"[!] Exception caught: {e}", file=sys.stderr)
      sys.exit(1)

  # Analyse response
  status = jsonResponse["status"]
  if status != "success":
    print(f"return of curl {url} is not status=success", file=sys.stderr)
    sys.exit(1)

  # Check content of result field
  result = jsonResponse["data"]["result"]
  if not result:
    print(f"Metric missing : {url}", file=sys.stderr)
    sys.exit(1)

  # Count the number of value inside result field. Initialize nb_results at 0.
  nb_results = 0
  for item in jsonResponse['data']['result']:
      nb_results += 1
      
  if nb_results == 0:
    print(f"No values.", file=sys.stderr)
    sys.exit(1)
    
  print(f"Got {nb_results} lines from {url}")

# loop stdin inputs with the checkmetric() function if -Q option is followed by -.
if args.QUERY == "-":
  STDIN = sys.stdin.read().strip().split('\n')
  count = len(STDIN)
  for idx in range(count):
    QUERY = STDIN[idx]
    checkMetric()

# Inputs are stored within a file. 
elif args.QUERY.startswith('@'):
  FILE_NAME = args.QUERY[1:]
  with open(FILE_NAME, 'r') as f:
    QUERY_LIST = [line for line in f]
    for idx, query in enumerate(QUERY_LIST):
      QUERY = query
      checkMetric()

# single execute checkmetrics if -Q option is used.
else:
  QUERY = args.QUERY
  checkMetric()

# If everything is OK, force exit(0)
sys.exit(0)
