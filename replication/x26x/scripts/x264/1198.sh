#!/bin/sh

numb='1199'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 45 --keyint 300 --lookahead-threads 0 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.2,1.0,0.6,0.5,0.6,0.4,0,2,4,45,300,0,24,10,4,3,64,18,3,1000,1:1,dia,crop,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"