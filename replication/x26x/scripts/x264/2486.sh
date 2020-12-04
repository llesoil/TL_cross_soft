#!/bin/sh

numb='2487'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 50 --keyint 260 --lookahead-threads 2 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.0,1.3,1.1,4.8,0.2,0.7,0.8,3,2,16,50,260,2,28,10,5,2,65,48,4,2000,1:1,umh,crop,medium,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"