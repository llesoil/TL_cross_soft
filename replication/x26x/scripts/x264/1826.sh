#!/bin/sh

numb='1827'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 25 --keyint 260 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.0,1.4,1.2,1.4,0.3,0.6,0.3,1,2,16,25,260,3,28,40,3,1,69,48,6,1000,1:1,dia,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"