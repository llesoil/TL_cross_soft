#!/bin/sh

numb='3037'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 30 --keyint 230 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.2,1.2,4.0,0.2,0.6,0.4,3,2,16,30,230,1,25,50,4,0,62,38,5,1000,1:1,dia,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"