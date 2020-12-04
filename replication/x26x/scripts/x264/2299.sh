#!/bin/sh

numb='2300'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 15 --keyint 250 --lookahead-threads 2 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.2,1.2,4.6,0.3,0.9,0.6,3,0,6,15,250,2,27,30,5,4,60,38,5,2000,1:1,hex,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"