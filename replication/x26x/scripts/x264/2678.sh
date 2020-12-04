#!/bin/sh

numb='2679'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 5.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 30 --keyint 270 --lookahead-threads 4 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.6,1.2,5.0,0.4,0.8,0.3,3,2,0,30,270,4,25,50,4,4,62,18,2,2000,-1:-1,umh,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"