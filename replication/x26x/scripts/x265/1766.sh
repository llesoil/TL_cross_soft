#!/bin/sh

numb='1767'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 45 --keyint 260 --lookahead-threads 4 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.5,1.3,1.8,0.5,0.8,0.2,1,2,2,45,260,4,24,10,5,4,65,28,4,1000,-2:-2,dia,crop,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"