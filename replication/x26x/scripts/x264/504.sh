#!/bin/sh

numb='505'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,2.0,1.0,1.3,4.8,0.4,0.6,0.9,3,2,8,50,210,2,20,10,3,2,60,48,3,1000,1:1,umh,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"