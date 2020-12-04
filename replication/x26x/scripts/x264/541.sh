#!/bin/sh

numb='542'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 5.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 10 --keyint 300 --lookahead-threads 2 --min-keyint 21 --qp 20 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,1.5,1.2,1.3,5.0,0.6,0.6,0.0,3,1,10,10,300,2,21,20,5,0,62,48,4,1000,1:1,umh,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"