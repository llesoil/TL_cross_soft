#!/bin/sh

numb='2235'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 0 --keyint 290 --lookahead-threads 1 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.0,1.4,3.6,0.2,0.6,0.8,1,0,14,0,290,1,22,30,3,1,62,48,5,1000,-2:-2,dia,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"