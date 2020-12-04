#!/bin/sh

numb='574'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 30 --keyint 290 --lookahead-threads 2 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.0,1.1,1.3,2.8,0.4,0.9,0.7,0,0,0,30,290,2,25,50,5,1,65,48,1,2000,1:1,dia,crop,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"