#!/bin/sh

numb='1057'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 50 --keyint 240 --lookahead-threads 0 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,1.5,1.3,1.1,2.2,0.4,0.9,0.7,0,1,8,50,240,0,28,40,3,1,68,48,4,2000,1:1,umh,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"