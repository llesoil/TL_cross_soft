#!/bin/sh

numb='308'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 15 --keyint 290 --lookahead-threads 1 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.3,1.2,4.6,0.4,0.8,0.0,3,2,10,15,290,1,28,40,4,2,60,48,5,1000,1:1,umh,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"