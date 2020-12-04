#!/bin/sh

numb='2347'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 10 --keyint 280 --lookahead-threads 4 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.3,3.6,0.4,0.8,0.0,2,0,6,10,280,4,29,20,3,2,69,38,4,1000,1:1,hex,crop,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"