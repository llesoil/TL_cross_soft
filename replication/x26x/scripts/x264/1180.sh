#!/bin/sh

numb='1181'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 30 --keyint 280 --lookahead-threads 0 --min-keyint 26 --qp 10 --qpstep 5 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.0,1.4,4.4,0.6,0.6,0.4,3,2,8,30,280,0,26,10,5,1,68,48,3,2000,-1:-1,umh,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"