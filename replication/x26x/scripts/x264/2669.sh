#!/bin/sh

numb='2670'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 45 --keyint 260 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.5,1.2,4.6,0.3,0.9,0.8,2,0,12,45,260,3,28,10,3,0,66,48,6,2000,1:1,hex,show,veryfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"