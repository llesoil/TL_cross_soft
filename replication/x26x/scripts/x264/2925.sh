#!/bin/sh

numb='2926'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 15 --keyint 210 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.5,1.3,1.6,0.5,0.9,0.0,2,2,12,15,210,0,26,20,3,2,61,38,4,2000,1:1,hex,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"