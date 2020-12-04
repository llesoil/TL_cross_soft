#!/bin/sh

numb='2759'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 35 --keyint 200 --lookahead-threads 4 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.1,1.2,3.0,0.2,0.7,0.7,0,0,6,35,200,4,28,50,3,2,62,48,3,2000,-1:-1,hex,show,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"