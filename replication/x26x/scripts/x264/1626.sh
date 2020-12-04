#!/bin/sh

numb='1627'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 35 --keyint 220 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.2,1.2,1.8,0.3,0.6,0.0,3,2,2,35,220,3,25,50,5,4,62,48,1,2000,-2:-2,umh,crop,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"