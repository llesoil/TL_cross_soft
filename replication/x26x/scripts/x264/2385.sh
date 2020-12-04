#!/bin/sh

numb='2386'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 45 --keyint 270 --lookahead-threads 2 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 0 --qpmax 67 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.3,1.0,0.4,0.8,0.8,2,1,10,45,270,2,27,20,3,0,67,28,1,1000,-2:-2,umh,crop,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"