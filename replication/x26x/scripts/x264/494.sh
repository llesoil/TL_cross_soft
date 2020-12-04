#!/bin/sh

numb='495'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 1.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 5 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,0.0,1.3,1.2,1.6,0.4,0.6,0.9,2,1,6,5,210,3,24,50,3,3,62,48,1,1000,1:1,hex,show,ultrafast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"