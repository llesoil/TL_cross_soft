#!/bin/sh

numb='633'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 12 --crf 0 --keyint 230 --lookahead-threads 2 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.5,1.1,1.1,1.2,0.3,0.7,0.1,2,2,12,0,230,2,27,50,5,1,61,48,6,1000,-1:-1,umh,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"