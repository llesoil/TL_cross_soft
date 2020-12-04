#!/bin/sh

numb='2921'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.0 --qblur 0.4 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 30 --keyint 260 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,2.0,1.4,1.0,1.0,0.4,0.6,0.3,1,0,0,30,260,4,27,40,5,4,62,18,5,2000,1:1,dia,crop,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"