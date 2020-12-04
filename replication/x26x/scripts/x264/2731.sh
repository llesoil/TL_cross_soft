#!/bin/sh

numb='2732'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 8 --crf 50 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 10 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,2.5,1.4,1.4,3.2,0.2,0.6,0.4,1,1,8,50,230,2,30,10,4,2,64,28,2,1000,1:1,dia,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"