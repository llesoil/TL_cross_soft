#!/bin/sh

numb='73'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 45 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.2,1.1,1.2,0.4,0.6,0.7,0,2,4,45,230,2,30,50,4,2,62,38,5,2000,1:1,dia,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"