#!/bin/sh

numb='863'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 40 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.4,1.2,1.6,0.6,0.7,0.5,0,2,2,40,230,4,30,50,4,3,65,38,3,2000,-1:-1,hex,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"