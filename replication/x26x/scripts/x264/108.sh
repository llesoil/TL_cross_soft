#!/bin/sh

numb='109'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 15 --keyint 290 --lookahead-threads 3 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.6,1.3,3.6,0.2,0.6,0.3,1,2,16,15,290,3,28,10,4,1,60,18,4,1000,-1:-1,umh,show,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"