#!/bin/sh

numb='2310'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 10 --keyint 230 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.1,1.4,2.4,0.5,0.6,0.8,0,1,4,10,230,2,28,20,5,1,67,18,4,1000,-1:-1,hex,show,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"