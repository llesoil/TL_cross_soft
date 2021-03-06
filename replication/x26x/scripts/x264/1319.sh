#!/bin/sh

numb='1320'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 45 --keyint 260 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.5,1.3,1.6,0.6,0.7,0.1,2,2,10,45,260,1,21,20,5,2,62,38,6,2000,1:1,dia,show,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"